{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01540') }},
        {{ ref('model_02023') }},
        {{ ref('model_01557') }}
)
select id, 'model_02631' as name from sources
