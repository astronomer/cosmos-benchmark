{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01974') }},
        {{ ref('model_01662') }}
)
select id, 'model_02883' as name from sources
