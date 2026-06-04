{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00054') }},
        {{ ref('model_00069') }},
        {{ ref('model_00510') }}
)
select id, 'model_01400' as name from sources
