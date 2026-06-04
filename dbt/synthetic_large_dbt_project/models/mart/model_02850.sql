{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02214') }},
        {{ ref('model_01568') }},
        {{ ref('model_01732') }}
)
select id, 'model_02850' as name from sources
