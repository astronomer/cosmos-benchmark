{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00581') }},
        {{ ref('model_00134') }}
)
select id, 'model_01211' as name from sources
