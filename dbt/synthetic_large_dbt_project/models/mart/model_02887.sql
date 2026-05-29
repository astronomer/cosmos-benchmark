{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01725') }},
        {{ ref('model_01948') }}
)
select id, 'model_02887' as name from sources
