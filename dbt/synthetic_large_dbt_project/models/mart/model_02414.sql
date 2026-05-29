{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02140') }},
        {{ ref('model_01882') }}
)
select id, 'model_02414' as name from sources
