{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02074') }},
        {{ ref('model_01995') }}
)
select id, 'model_02515' as name from sources
