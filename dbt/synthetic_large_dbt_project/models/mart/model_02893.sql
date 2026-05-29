{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02206') }},
        {{ ref('model_02067') }}
)
select id, 'model_02893' as name from sources
