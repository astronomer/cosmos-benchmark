{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01115') }},
        {{ ref('model_01443') }}
)
select id, 'model_01521' as name from sources
