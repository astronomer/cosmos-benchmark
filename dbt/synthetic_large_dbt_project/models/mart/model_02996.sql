{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01521') }},
        {{ ref('model_02012') }}
)
select id, 'model_02996' as name from sources
