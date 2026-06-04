{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00737') }},
        {{ ref('model_00582') }},
        {{ ref('model_00259') }}
)
select id, 'model_01496' as name from sources
