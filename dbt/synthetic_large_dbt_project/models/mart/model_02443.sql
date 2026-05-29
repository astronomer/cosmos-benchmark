{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02225') }},
        {{ ref('model_02069') }}
)
select id, 'model_02443' as name from sources
