{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01798') }},
        {{ ref('model_02206') }},
        {{ ref('model_01522') }}
)
select id, 'model_02383' as name from sources
