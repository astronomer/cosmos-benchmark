{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01292') }},
        {{ ref('model_01372') }}
)
select id, 'model_02021' as name from sources
