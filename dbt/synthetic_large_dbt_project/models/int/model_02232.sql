{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01152') }},
        {{ ref('model_01136') }},
        {{ ref('model_01144') }}
)
select id, 'model_02232' as name from sources
